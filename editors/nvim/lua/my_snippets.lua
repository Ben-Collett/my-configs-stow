local M = {}
local function define_auto_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s({ trig = trig, snippetType = "autosnippet", wordTrig = true }, fmt(content, args)) })
end

local function define_manual_snippet(language, trig, content, args, ls, s, fmt)
  ls.add_snippets(language, { s(trig, fmt(content, args)) })
end

local function dart(ls, s, t, i, fmt, rep)
  local args = {i(1,"className"),i(2),i(3)}
  local content = "class {}{{\n  {}\n}}{}"
  define_auto_snippet("dart", "DECLARE_CLASS_PLZ", content, args, ls, s, fmt)
  args = {i(1,"className"),i(2),i(3)}
  content = "class {}{{\n  {}\n}}{}"
  define_auto_snippet("dart", "cll", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value"),i(3)}
  content = "final {} = {};{}"
  define_auto_snippet("dart", "immutable", content, args, ls, s, fmt)
  args = {i(1,"int"),i(2,"name"),i(3,"value")}
  content = "{} get {}=>{};"
  define_auto_snippet("dart", "getter_fat_arrow", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"iterable"),i(3),i(4)}
  content = "for(const {} in {}) {{\n  {}\n}}{}"
  define_auto_snippet("dart", "fcc", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"int"),i(3,"value"),i(4,"content"),i(5)}
  content = "set {}({} {}){{\n  {}\n}}{}"
  define_auto_snippet("dart", "setter", content, args, ls, s, fmt)
  args = {i(1,"conditional"),i(2),i(3)}
  content = "if({}){{\n  {}\n}}{}"
  define_auto_snippet("dart", "iff", content, args, ls, s, fmt)
  args = {i(1,"void"),i(2,"name"),i(3,"params"),i(4,"content"),i(5)}
  content = "{} {}({}){{\n  {}\n  }}{}"
  define_auto_snippet("dart", "DECLARE_FUNCTION_PLZ", content, args, ls, s, fmt)
  args = {i(1,"void"),i(2,"name"),i(3,"params"),i(4,"content"),i(5)}
  content = "{} {}({}){{\n  {}\n  }}{}"
  define_auto_snippet("dart", "fuu", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value"),i(3)}
  content = "const {} = {};{}"
  define_auto_snippet("dart", "DECLARE_CONST_PLZ", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value"),i(3)}
  content = "const {} = {};{}"
  define_auto_snippet("dart", "coo", content, args, ls, s, fmt)
  args = {i(1,"var"),i(2,"name"),i(3,"value"),i(4)}
  content = "{} {} = {};\n{}"
  define_auto_snippet("dart", "DECLARE_VAR_PLZ", content, args, ls, s, fmt)
  args = {i(1,"var"),i(2,"name"),i(3,"value"),i(4)}
  content = "{} {} = {};\n{}"
  define_auto_snippet("dart", "mtt", content, args, ls, s, fmt)
  args = {i(1,"content"),i(2)}
  content = "print({});{}"
  define_auto_snippet("dart", "prr", content, args, ls, s, fmt)
  args = {i(1,"content"),i(2)}
  content = "print({});{}"
  define_auto_snippet("dart", "PRINT_PLZ", content, args, ls, s, fmt)
  args = {i(1,"void"),i(2,"name"),i(3,"params"),i(4,"content")}
  content = "{} {}({}) => {}"
  define_auto_snippet("dart", "function_short", content, args, ls, s, fmt)
  args = {i(1,"int"),i(2,"name"),i(3,"content"),i(4,"return"),i(5)}
  content = "{} get {}{{\n  {}\n  return {};\n}}{}"
  define_auto_snippet("dart", "getter", content, args, ls, s, fmt)
end
local function java(ls, s, t, i, fmt, rep)
  local args = {i(1,"toPrint")}
  local content = "System.out.println({});"
  define_manual_snippet("java", "sout", content, args, ls, s, fmt)
  args = {i(1,"toPrint")}
  content = "System.out.println({});"
  define_auto_snippet("java", "PRINT_PLZ ", content, args, ls, s, fmt)
end
local function python(ls, s, t, i, fmt, rep)
  local args = {i(1,"className"),i(2,"pass")}
  local content = "def {}:\n  {}\n"
  define_auto_snippet("python", "DECLARE_CLASS_PLZ", content, args, ls, s, fmt)
  args = {i(1,"className"),i(2,"pass")}
  content = "def {}:\n  {}\n"
  define_auto_snippet("python", "cll", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value"),i(3)}
  content = "final {} = {};{}"
  define_auto_snippet("python", "immutable", content, args, ls, s, fmt)
  args = {i(1,"conditional"),i(2,"pass")}
  content = "if({}):\n  {}"
  define_auto_snippet("python", "iff", content, args, ls, s, fmt)
  args = {i(1,"params"),i(2,"pass")}
  content = "def name({}):\n  {}"
  define_auto_snippet("python", "DECLARE_FUNCTION_PLZ", content, args, ls, s, fmt)
  args = {i(1,"params"),i(2,"pass")}
  content = "def name({}):\n  {}"
  define_auto_snippet("python", "fuu", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value")}
  content = "{} = {}"
  define_auto_snippet("python", "DECLARE_CONST_PLZ", content, args, ls, s, fmt)
  args = {i(1,"name"),i(2,"value")}
  content = "{} = {}"
  define_auto_snippet("python", "coo", content, args, ls, s, fmt)
  args = {i(1,"pass")}
  content = "def __init__(self):\n  {}"
  define_auto_snippet("python", "init", content, args, ls, s, fmt)
  args = {i(1,"")}
  content = "print({})"
  define_auto_snippet("python", "prr", content, args, ls, s, fmt)
  args = {i(1,"")}
  content = "print({})"
  define_auto_snippet("python", "PRINT_PLZ", content, args, ls, s, fmt)
end
function M.set_up_snippets(ls, s, t, i, fmt, rep)
  dart(ls, s, t, i, fmt, rep)
  java(ls, s, t, i, fmt, rep)
  python(ls, s, t, i, fmt, rep)
end


--don't copy if you are not using as external module
return M