local composer = require( "composer" )
 
local scene = composer.newScene()local widget = require( "widget" )



display.setDefault( "background", .8,0, 0 )


 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
	
	local sceneGroup = self.view
	local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }
	sceneGroup:insert( bg2 )
	
    --local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	--display.setDefault( "background", 0.8,0, 0 )
	-- Vars
	CountryArray = {}
	CountryToDisplay = {}
	flag = 0
	FirstTimeFlag = 0
	counter = 2
	--Groups
	ButtonGroup = display.newGroup()
	debugGroup = display.newGroup()
	

	
	

---------------------------------------------------------------------FUNCTIONS--------------------------------------------
-------------------------
-- Handle Next Button
--
function handleNextButton (event,self)
 if ( event.phase == "ended" ) then
	 print(event.target.id)
	 print(CountryArray[event.target.id])
	 --display.remove( flagGroup )
	 --flagGroup = nil
	 --displayATable(event.target.id)

	end
	
end

----------------------
--Handle Flag Press
--
function handleFlagEvent (event,self)
		
		print(counter)
		
		if (counter > 110)then
			counter = 2
		end
		if ( event.phase == "ended" ) then
			displayFlags()
		end
		
	
end

local function goBack()
	defaultField:removeSelf()
	-- Completely remove the scene, including its scene object
    composer.removeScene( "ViewByCountry" )
	composer.gotoScene( "mainmenuScene", { time=800, effect="crossFade" } )
end

--Get the text from the textbox ie the search term, TEXT TERM ENTERED
--Call findChars to get results 
-- Should: Clear Buttons, Clear Rows, Clear Debug
-- ButtonGroup: Country Buttons

local function textListener( event )
		-- Clear Debug Group Remove form display
		display.remove( debugGroup )
		dubugGroup = nil
		debugGroup = display.newGroup()
		--Clear Button Group Remove form display
		display.remove( ButtonGroup )
		ButtonGroup = nil
		ButtonGroup = display.newGroup()
		
		display.remove( flagGroup )
		flagGroup = nil
		
		-- If there is a tableView on the screen at the moment. 
		--Kill It/Remove it
		if (FirstTimeFlag == 1) then
			tableView:deleteAllRows()
		end
		-- Enter letter is entered on the phone keyboard.
		if (  event.phase == "submitted" ) then
	
			--Remove ButtonGroup and start another. Clears the results text. 
			display.remove( ButtonGroup )
			ButtonGroup = nil
			ButtonGroup = display.newGroup()
			
			-- Get text string from text box
			local someString = event.target.text
			if someString ~= "" then
				anotherString = string.lower(someString)
				--Search Chars
				findChars(CountryArray, anotherString)
				defaultField.text = ""
				
				else -- Text box is empty
				print("BLANK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					myText = display.newText(debugGroup,"Please enter a search term!",display.contentCenterX,display.contentCenterY-180, native.systemFont, 22)
					myText:setFillColor( 0.8, 0, 0 )
					debugGroup:insert(myText)
					sceneGroup:insert(debugGroup)
			end	

		end
end

--Make a Country Array
--Ignors commas, "
--Convers Case to lower
function makeArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = string.lower(constring..c)
			else
				if(constring ~= "")then -- I am leaving this but it does nothing
					array[#array + 1] = constring
					constring = ""
				else
					constring = ""
				end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end

--Make an Array
--Ignors commas, "

function rawArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = (constring..c)
			else
				if(constring ~= "")then -- I am leaving this but it does nothing
					array[#array + 1] = constring
					constring = ""
				else
					constring = ""
				end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end


--Search partial string, not case sensitive. ie "A" or "Aust" etc
-- Display results as Buttons
--
function findChars(array,search) 
	
	local someString = ""
	local startpos = 200
	local counter = 0 --match counter
	local flag = 0
	local foundArray= {}
	k = 1
	--Comapare each charater in the string, count the matches
	for i = 2, #array  do --Start at index 2 to disclude the headers ie Country, Country Code etc.**WALK AROUND!!
		local success = 0
		someString = array[i]
		for k = 1, #someString do
			local c = someString:sub(k,k)--Get the chars to compare
			local d = search:sub(k,k)
			if (c == d) then --If chars the same increment match count
				success = success + 1
					else 
						success = success + 0	
			end
		end
		--If the matches are the lenght of the string
		--Create a Country button.

		if (success == #search)then
			
			
			counter = counter + 1 -- For button Spacing on Y axis.See var 'top' below
			print("Found "..array[i].. " at index position "..i) --Debug	
			foundArray[k] = i
			k = k +1
			flag = 1 -- Found search term Flag
			--[[
			local Sstr = i
			local Sstr = widget.newButton -- Make Button
			{
				shape = "roundedRect",
				fontSize = 17,
				left = 35,
				top = (30 * counter) + 20,
				width = 250,
				height = 20,
				id = i,
				label = array[i],
				strokeWidth=12,
				labelColor = { default={ 0, 0.3, 1 }, over={ 1, 1, 1, 0.5 } },
				fillColor = { default={ .1, 0.2, 0.7, 0.5 },over={ 1, 0.2, 0.5, 1 }}, 
				emboss=false,
				cornerRadius=8,
				--onRelease = handleButtonEvent --Not needed have event listener below
			}
			-- Button event Handler for each button created. 
			Sstr:addEventListener( "touch", handleButtonEvent ) 
			ButtonGroup:insert(Sstr) --Make a group so we can remove them from the screen.
			-]]
			
		end		
	end
	
	for i = 1, #foundArray do
	print(foundArray[i])
	end
	displayF(foundArray)
	
	if(flag ~= 1) then --Search term Not Found.
		myText = display.newText(debugGroup,"Search Term Not Found!\n    Please Try Again",display.contentCenterX,startpos + (20*counter), 240, 300, native.systemFont, 22)
		myText:setFillColor( 0.8, 0, 0 )
		debugGroup:insert(myText)
		sceneGroup:insert(debugGroup)
	end
end

function displayF(arr)
local posiArray = {display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100, display.contentCenterX - 100, display.contentCenterX , 
					display.contentCenterX + 100,display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,display.contentCenterX - 100, 
					display.contentCenterX , display.contentCenterX + 100,display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100} 	

CountryArray = makeArray(country)
displayArray = rawArray(country)
	display.remove( flagGroup )
		flagGroup = nil
		flagGroup = display.newGroup()	
		
		

--couter = nums
 for i = 1, #arr   do

	if (i < 4) then
		yaxis = 80
end
	if(i > 3 and i < 7)then
		yaxis = 160
	end
	if(i > 6 and i < 10)then
		yaxis = 240
	end
	if(i > 9 and i < 13)then
		yaxis = 320
	end
	if(i > 12 )then
		yaxis = 420
	end
	print(CountryArray[arr[i]])
	someString = CountryArray[arr[i]]..".png"
	image2 = display.newImageRect(flagGroup,someString, 50, 50)
	text2 = display.newText(flagGroup,displayArray[arr[i]],posiArray[i] +20,yaxis + 35,90,0,native.systemFont,13)
	image2.x = (posiArray[i])
	image2.y = yaxis
	print(someString)
	image2.id = arr[i]
	image2:addEventListener( "touch", handleNextButton )
	flagGroup:insert(image2)
	flagGroup:insert(text2)
	i = i + 1
	
	end
	--return counter
	--counter = counter + (i-2)
	sceneGroup:insert( flagGroup )
end


--Display Flags
--
function displayFlags(arr)
local posiArray = {0,display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100, display.contentCenterX - 100, display.contentCenterX , 
					display.contentCenterX + 100,display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,display.contentCenterX - 100, 
					display.contentCenterX , display.contentCenterX + 100} 	

CountryArray = makeArray(country)
displayArray = rawArray(country)
	display.remove( flagGroup )
		flagGroup = nil
		flagGroup = display.newGroup()	
		
		
local nextButton = widget.newButton(
	{
	    label = "NEXT",
        onEvent = handleFlagEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
		fontSize = 17,
        width = 100,
        height = 20,
		id = i,
        cornerRadius = 12,
       labelColor = { default={ 0, 0.3, 1 }, over={ 1, 1, 1, 0.5 } },
				fillColor = { default={ .1, 0.2, 0.7, 0.5 },over={ 1, 0.2, 0.5, 1 }},
        strokeWidth = 12
	}
	)
nextButton.x = display.contentCenterX + 90
nextButton.y = display.contentCenterY + 200
i = 2

flagGroup:insert(nextButton)

--couter = nums
 for counter = counter, counter + 11 do
	if(counter > 114)then 
		i = 4
		counter = 0
		break
	end
	if (i < 5) then
		yaxis = 80
end
	if(i > 4 and i < 8)then
		yaxis = 160
	end
	if(i > 7 and i < 11)then
		yaxis = 240
	end
	if(i > 10)then
		yaxis = 320
	end
	someString = CountryArray[counter]..".png"
	image2 = display.newImageRect(flagGroup,someString, 50, 50)
	text2 = display.newText(flagGroup,displayArray[counter],posiArray[i] +20,yaxis + 35,90,0,native.systemFont,13)
	image2.x = (posiArray[i])
	image2.y = yaxis
	print(someString)
	image2.id = counter
	image2:addEventListener( "touch", handleNextButton )
	flagGroup:insert(image2)
	flagGroup:insert(text2)
	i = i + 1
	
	end
	--return counter
	counter = counter + (i-2)
	sceneGroup:insert( flagGroup )
end


-- Function to handle button events 
-- Country Button Pressed!!!
-- 
function handleButtonEvent( event,self )

		--clear DebugGroup Remove from Screen!
		display.remove( debugGroup )
		dubugGroup = nil
		debugGroup = display.newGroup()
		
		

    if ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        print( "touch ended on object " .. tostring(event.target.id) )
-- Create Table View
		tableView = widget.newTableView(
			{
			left = 0,
			top = 45,
			height = 500,        --Height and width of the actual Table View
			width = display.ContentWidthX ,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener,
			hideBackground = true
			}
		)
		for i = 1, 57 do          -- 57 the amount of lines in the flat file! TODO full proof this!
			response = getRow(i)
			local dummyArray = {}
			local titleArray = {}
			dummyArray = makeArray(response)
			CountryToDisplay[i] = dummyArray[event.target.id]
			titleArray[i] = dummyArray[1]
			print(CountryToDisplay[i])
			
			--print(dummyArray[i])
			dummyArray = nil -- Kill It.
			
			local isCategory = false
			local rowHeight = 70 ----------------------------------------ROW HEIGHT get the majic right.
			local rowColor = { default={ 0, 0, 0}, over={ 0, 0, 0} }
			local lineColor = { 0, 0, 0 }
			--print( string.find( "Hello Corona user", "Corona" ) ) 
			
			local SectionString = titleArray[i]
			local DataString = CountryToDisplay[i]
			SectionString = SectionString:gsub("%a", string.upper,1) --Make First letter a capital
			DataString = DataString:gsub("%a", string.upper,1)
			local id = SectionString.." = "..DataString --Concat output to display
			
-- Insert a row into the tableView
			tableView:insertRow(
				{
					isCategory = isCategory,
					rowHeight = rowHeight,
					rowColor = rowColor,
					lineColor = lineColor,
					id = id,
				    --params = {}  -- Include custom data in the row               **TODO but not needed.
				}
			)		
		end
			FirstTimeFlag = 1 --Are there any tables being displayed? see function textListener.
    end 
return true  -- Prevents tap/touch propagation to underlying objects
end
	
----------------------------------------------------------------Fuctions End--------------------------------------------	
flagGroup = display.newGroup()
backLayer = display.newGroup()
-- Create text field
local background = display.newImage(backLayer, "bg_map_dotted.png", 30, 140)
-- Remove the object
defaultField = native.newTextField( 160, 25, 180, 30 )
defaultField:addEventListener( "userInput", textListener )
SearchTitle = display.newText(backLayer,"Search",display.contentCenterX,0, 0, 0, native.systemFont, 14)
SearchTitle:setFillColor( 1, 1, 1 )					

--defaultField:removeSelf()


	-- Button widget for the Go Back button
	backButton = widget.newButton(
		{
			onRelease = goBack,
			x = 29,
			y = 496,
			width = 40,
			height = 40,
			defaultFile = "backButtonDefault.png",
			overFile = "backButtonPressed.png"
		}
	)
	backLayer:insert(backButton)
local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )

local file = io.open(path, "r")
if file then
	--print("File Found")
	country = file:read("*l")
	--code = file:read("*l")
	--region = file:read("*l")
	io.close (file)
	print("File Loaded Ok")
	else
		print("Not working") --No file/Error
end


displayFlags()
local diaplayArray = rawArray(country)
print(country) --Debug

	-- insert my display objects (grouped as "uiGroup") into the "sceneGroup"
	sceneGroup:insert( backLayer )
	sceneGroup:insert( flagGroup )
	

end

 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		
	
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene