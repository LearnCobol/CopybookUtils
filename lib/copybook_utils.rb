require 'copybook_utils/version'
require 'copybook_utils/convert_file'
require 'convert_methods'
require 'open3'

module CopybookUtils
    # defines native methods ebcdic2ascii and ascii2ebcdic
    extend CONVERT_METHODS
    
    class << self
        def copybook_to_xml copybook_filename
            path = File.expand_path(File.dirname(__FILE__))
            cmd = "java -jar #{path}/cb2xml-0.95.1/cb2xml.jar #{copybook_filename}"
            stdout, stderr, status = Open3.capture3(cmd)
            { :xml => stdout, :error_out => stderr, :process_status => status }
        end

        def to_ascii copybook_xml, from_filename, to_filename
            converter = CopybookUtils::ConvertFile.new
            converter.convert_file method(:ebcdic2ascii), copybook_xml, from_filename, to_filename
        end

        def to_ebcdic copybook_xml, from_filename, to_filename
            converter = CopybookUtils::ConvertFile.new
            converter.convert_file method(:ascii2ebcdic), copybook_xml, from_filename, to_filename
        end
    end
end
