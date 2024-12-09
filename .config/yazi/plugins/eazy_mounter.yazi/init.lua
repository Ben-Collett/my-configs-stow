
print('hello') 
-- Step 1: Define the area (Rect) for the table
local area = ui.Rect { x = 0, y = 0, w = 60, h = 20 }

-- Step 2: Create some Lines to display in the table (linesLayout)
local linesLayout = {
    ui.Line { ui.Span("Line 1: Item A"), ui.Span(" | "), ui.Span("Item B") },
    ui.Line { ui.Span("Line 2: Item C"), ui.Span(" | "), ui.Span("Item D") },
    ui.Line { ui.Span("Line 3: Item E"), ui.Span(" | "), ui.Span("Item F") },
    -- Add more lines as needed
}

-- Step 3: Create a List to hold these Lines
local list = ui.List(linesLayout)

-- Step 4: Apply a style to the List (optional)
local style = ui.Style():fg("white"):bg("blue"):bold()
list:style(style)

-- Step 5: Add a Border or Bar (optional)
local border = ui.Border(ui.Border.ALL):style(ui.Style():fg("cyan"):bg("black"):bold())
local bar = ui.Bar(ui.Bar.TOP):style(ui.Style():fg("green"):bg("black"))

-- Step 6: Combine elements using Layout
local layout = ui.Layout()
    :direction(ui.Layout.VERTICAL)
    :constraints({
        ui.Constraint.Percentage(100),
    })
    :split(area)

-- Step 7: Render the UI
components = {
    list:area(layout[1]),  -- Add the List to the layout area
    border:area(layout[1]),  -- Optionally add a border around the list
    bar:area(layout[1]),  -- Optionally add a top bar
}

-- Display the components
ui.Display(components)
