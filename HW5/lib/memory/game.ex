defmodule Memory.Game do

	def new do		
		%{
			tiles: init(),
			activeTile: nil,
		    score: 0,
		    matched: "",
		    flipback: nil
		}
	end

	def client_view(game) do
		%{
			skel: game.tiles,
			points: game.score,
			flipback: game.flipback,
			matched: game.matched
		}
	end

	def init() do
		tiles = [
	      %{letter: "H", flip: false, match: false},
	      %{letter: "E", flip: false, match: false},
	      %{letter: "A", flip: false, match: false},
	      %{letter: "C", flip: false, match: false},
	      %{letter: "B", flip: false, match: false},
	      %{letter: "G", flip: false, match: false},
	      %{letter: "D", flip: false, match: false},
	      %{letter: "F", flip: false, match: false},
	      %{letter: "B", flip: false, match: false},
	      %{letter: "G", flip: false, match: false},
	      %{letter: "H", flip: false, match: false},
	      %{letter: "F", flip: false, match: false},
	      %{letter: "E", flip: false, match: false},
	      %{letter: "C", flip: false, match: false},
	      %{letter: "D", flip: false, match: false},
	      %{letter: "A", flip: false, match: false}
	    ]
	    Enum.shuffle(tiles)
	end

	def handleTileClick(game, r, c) do
		score = game.score
		clickedTile = Enum.at(game.tiles, twodtooned(r, c)) 
		if !clickedTile.flip do
			newGameState = checkHit(game, clickedTile.letter, r, c)
		else
			newGameState = game
		end
		newGameState
	end

	def checkHit(game, letter, r, c) do
		tiles = game.tiles
		matched = game.matched
		activeTile = nil
		flipback = game.flipback
		clickedTile = Enum.at(game.tiles, twodtooned(r, c))
		score = game.score
		clickedTile = Map.replace!(clickedTile, :flip, true)
		tiles = List.replace_at(tiles, twodtooned(r, c), clickedTile)		
		if game.activeTile != nil do
			actTile = Enum.at(game.tiles, twodtooned(game.activeTile[:row], game.activeTile[:col]))
			if clickedTile.letter === game.activeTile[:letter] do
				clickedTile = Map.replace!(clickedTile, :match, true)				
				actTile = Map.replace!(actTile, :match, true)
				tiles = List.replace_at(tiles, twodtooned(game.activeTile[:row], game.activeTile[:col]), actTile)
				tiles = List.replace_at(tiles, twodtooned(r, c), clickedTile)
				activeTile = nil
				score = score + 10
				matched = matched <> letter
			else				
				flipback = [r, c, game.activeTile[:row], game.activeTile[:col]]
				activeTile = nil
				score = score - 1				
			end			
		else
			score = score - 1
			activeTile = %{:row => r, :col => c, :letter => letter}
		end		
		%{
			tiles: tiles,
			activeTile: activeTile,
		    score: score,
		    matched: matched,
		    flipback: flipback
		}
	end

	def flipBackTiles(game) do
		tiles = game.tiles
		matched = game.matched
		activeTile = nil
		r1 = game.flipback |> Enum.at(0)
		c1 = game.flipback |> Enum.at(1)
		r2 = game.flipback |> Enum.at(2)
		c2 = game.flipback |> Enum.at(3)
		clickedTile = Enum.at(game.tiles, twodtooned(r1, c1))
		score = game.score
		actTile = Enum.at(game.tiles, twodtooned(r2, c2))
		:timer.sleep(1000)
		clickedTile = Map.replace!(clickedTile, :flip, false)
		actTile = Map.replace!(actTile, :flip, false)
		tiles = List.replace_at(tiles, twodtooned(r2, c2), actTile)
		tiles = List.replace_at(tiles, twodtooned(r1, c1), clickedTile)				
		flipback = nil
		%{
			tiles: tiles,
			activeTile: activeTile,
		    score: score,
		    matched: matched,
		    flipback: flipback
		}
	end

	def twodtooned(r, c) do
		r*4 + c
	end
	
end