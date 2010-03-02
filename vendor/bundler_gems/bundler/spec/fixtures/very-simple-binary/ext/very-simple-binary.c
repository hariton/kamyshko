#include "ruby.h"

VALUE method_works(VALUE self) {
  return Qtrue;
}

void Init_very_simple_binary() {
  VALUE VerySimpleBinary = rb_define_module("VerySimpleBinaryForTests");
  rb_define_method(VerySimpleBinary, "working", method_works, 0);
}