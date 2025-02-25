return {
  entry = function ()
   -- local value, event = ya.input {
    --  title = "ezmount:",
    --  position = {'top-center',y=3,w=40},
    --}
    local cand = ya.which{
      cands = {
        {on = 'c'},
        {on = 'b', desc = 'des'},
    }
  }
  end
}
