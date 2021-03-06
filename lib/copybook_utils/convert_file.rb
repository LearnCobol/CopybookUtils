require 'nokogiri'

module CopybookUtils
    class ConvertFile
        def convert_file conversion_method, copybook_xml, from_filename, to_filename
            doc = Nokogiri.XML(copybook_xml)

            @conversion_method = conversion_method
            @record_fields = []
            flatten_xml 0, 0, doc.root.children
            record_length = @record_fields[-1][:start] + @record_fields[-1][:length]

            convert record_length, from_filename, to_filename
        end

        private

        def convert_record str
            @record_fields.each do |field|
                start = field[:start]
                len = field[:length]
                converter = field[:conversion_method]
                str[start,len] = converter.(str[start,len]) if !converter.nil?
            end
            str
        end

        def convert record_length, from_filename, to_filename
            puts "Record length #{record_length}"
            record_count = 0
            File.open(from_filename) do |input|
                File.open(to_filename, "w") do |output|
                    while str = input.read(record_length) do
                        puts "Input file not a multiple of #{record_length}" if str.length != record_length
                        len = output.write(convert_record(str))
                        record_count += 1
                        puts "Write failed to output #{record_length} bytes, wrote #{len} bytes." if len != record_length
                    end
                end
            end
            puts "Converted #{record_count} records."
        end

        def flatten_xml level, offset, tree
            tree.each do |node| 
                # Note: The first definition is taken for determining how to convert (i.e.: redefines are ignored)
                next if !node['redefines'].nil?

                occurs = (node['occurs'] || "1").to_i - 1
                (0..occurs).each do |i|
                    new_offset = node['storage-length'].to_i * i
                    if node.name == 'item'
                        ignoring = node['picture'].nil? && node['numeric'].nil?
                        binary = !((node['usage'] || '') =~ /^comp/).nil?
                        position = node['position'].to_i + offset - 1
                        @record_fields << { :start => position, :length => node['storage-length'].to_i,
                                            :conversion_method => binary ? nil : @conversion_method } if !ignoring
                    end
                    flatten_xml level+1, offset+new_offset, node.children
                end
            end
        end
    end
end
