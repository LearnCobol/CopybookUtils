# CopybookUtils

Commands to convert fixed-record files described by a copybook record layout
from EBCDIC to ASCII, converting only the alpha-numeric fields.

The Gem can also be used to create scripts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'copybook_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install copybook_utils

## Command-line Usage

A command ```convert_from_ebcdic``` is in the gem ```bin``` directory. It is
recommended to copy ```convert_from_ebcdic``` from the bin directory to an
appropriate place on your system (also copy ```convert_from_ebcdic.bat``` to
the same place if on a Windows system).

Run the command from a terminal or command prompt. The command usage is:

```convert_from_ebcdic <Copybook file> <EBCDIC data file> <ASCII converted
file>```

This command parses the ```copybook file``` that contains the record layout for
the ```EBCDIC data file```. The ```EBCDIC data file``` is read record by record
converting the alpha-numeric fields from EBCDIC to ASCII. The output is written
to ```ASCII converted file```.

All binary fields (e.g.: comp-3, etc) are copied from the input records to the
output records unchanged.

## Gem Usage

To use CopybookUtils:

```require 'copybook_utils'```

### Converting Copybooks to XML

To convert a copybook to XML (wrapper around cb2xml Java jar from the copybook
to XML project):

```result = CopybookUtils.copybook_to_xml( copybook_filename )```

Result contains:

```
result[:xml]            # XML string representing copybook
result[:error_out]      # error info from conversion process
result[:process_status] # the Process::Status from running java; non-zero is an error
```

The XML may be parsed with your favorite XML parser (e.g.: Nokogiri).

### Converting Data Files between ASCII and EBCDIC

```
CopybookUtils.to_ascii( copybook_xml, data_file_input, data_file_output )
CopybookUtils.to_ebcdic( copybook_xml, data_file_input, data_file_output )
```

These methods take the XML from ```CopybookUtils.copybook_to_xml``` and convert
the ```data_file_input``` creating the ```data_file_output```. The input file
must be a fixed-record file with the record layout described by the copybook.
Note that fixed-record files do not have newlines at the end of each record.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/copybook_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
