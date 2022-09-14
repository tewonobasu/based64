open Ctypes
module Types = Types_generated

module Functions (F : FOREIGN) = struct
  open F

  let base64_encode = foreign "base64_encode" (string @-> size_t @-> ptr char @-> ptr size_t @-> int @-> returning void)
end
