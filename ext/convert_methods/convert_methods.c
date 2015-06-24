#include <ruby.h>
#include "tables.h"

VALUE CONVERT_METHODS = Qnil;
VALUE ebcdic2ascii(VALUE self, VALUE payload);
VALUE ascii2ebcdic(VALUE self, VALUE payload);

void Init_convert_methods() {
    CONVERT_METHODS = rb_define_module("CONVERT_METHODS");
    rb_define_method(CONVERT_METHODS, "ebcdic2ascii", ebcdic2ascii, 1);
    rb_define_method(CONVERT_METHODS, "ascii2ebcdic", ascii2ebcdic, 1);
}

static VALUE convert( VALUE self, VALUE ruby_string, const unsigned char conversion_table[] ) {
    u_char *input_string;
    u_char *output_string;
    u_char *dest;
    long    input_string_length;
    long    count;
    VALUE   return_string;

    if (TYPE(ruby_string) != T_STRING)
        rb_raise(rb_eRuntimeError, "expecting string, received %d", TYPE(ruby_string));

    input_string = (u_char *)RSTRING_PTR(ruby_string);
    input_string_length = RSTRING_LEN(ruby_string);
    output_string = malloc(input_string_length);

    count = input_string_length;
    dest = output_string;
    while (count-- != 0) {
        *dest++ = conversion_table[*input_string++];
    }
    return_string = rb_str_new((const char *)output_string, input_string_length);
    free(output_string);
    return return_string;
}

VALUE ebcdic2ascii( VALUE self, VALUE ruby_string ) {
    return convert( self, ruby_string, os_toascii );
}

VALUE ascii2ebcdic( VALUE self, VALUE ruby_string ) {
    return convert( self, ruby_string, os_toebcdic );
}
