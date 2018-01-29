import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root) {
  ReactDOM.render(<Game />, root);
}

function iniTiles() {
  return[
    [{letter: 'H', flip: false, match: false},
    {letter: 'E', flip: false, match: false},
    {letter: 'A', flip: false, match: false},
    {letter: 'C', flip: false, match: false}],
    [{letter: 'B', flip: false, match: false},
    {letter: 'G', flip: false, match: false},
    {letter: 'D', flip: false, match: false},
    {letter: 'F', flip: false, match: false}],
    [{letter: 'B', flip: false, match: false},
    {letter: 'G', flip: false, match: false},
    {letter: 'H', flip: false, match: false},
    {letter: 'F', flip: false, match: false}],
    [{letter: 'E', flip: false, match: false},
    {letter: 'C', flip: false, match: false},
    {letter: 'D', flip: false, match: false},
    {letter: 'A', flip: false, match: false}]
  ];
}

class Game extends React.Component {

  constructor(props) {
    super(props);
    this.reset = this.reset.bind(this);  
    this.checkHit = this.checkHit.bind(this);
    this.state = {
      tiles: _.shuffle(iniTiles()),
      activeTile: null,
      score: 0,
      inactive: false,
      matched: ""
    };  
  }

  tileClick(r,c) {
    if (!this.state.tiles[r][c].flip) {
      this.checkHit(this.state.tiles[r][c].letter, r, c);      
    }
  }

  checkHit(letter, r, c) {
    if (this.state.inactive) {
      return;
    }
    // Attribution: https://github.com/jdlehman/react-memory-game
    var tiles = this.state.tiles;
    tiles[r][c].flip = true;
    this.setState({tiles, inactive: true});
    if (this.state.activeTile) {
      if (letter === this.state.activeTile.letter) {
        tiles[r][c].match = true;
        tiles[this.state.activeTile.r][this.state.activeTile.c].match = true; 
        this.setState({tiles, activeTile: null, score: this.state.score + 5, inactive: false, matched: this.state.matched + letter});                
      } else {
        setTimeout(() => {
          tiles[r][c].flip = false;
          tiles[this.state.activeTile.r][this.state.activeTile.c].flip = false;
          this.setState({tiles, activeTile: null, score: this.state.score - 1, inactive: false});
        }, 1000);
      }
    } else {
      this.setState({
        activeTile: {r, c, letter},
        inactive: false
      });
    }
    if(this.state.matched.length === 7 && this.state.activeTile!=null) {
      alert("You win! Score: " + (this.state.score+5));
    }
  }

  reset() {
    this.setState({
      tiles: _.shuffle(iniTiles()),
      activeTile: null,
      score: 0,
      inactive: false,
      matched: ""
    });
  }

  render() {
    return (
      <div className="col">
        <div className="side">
          <button onClick={this.reset}>Play Again!</button>
          <p>Score: {this.state.score}</p>
        </div>
        <br /> <br />
        <div className="Grid">
          <table align="center">
            <tbody>
              {
                this.state.tiles.map(
                  (rowOfTiles, rowIndex) => 
                    <tr>
                      {rowOfTiles.map(
                        (tile, colIndex) => 
                          <td align="center" onClick={() => this.tileClick(rowIndex, colIndex)}>
                            <Tile
                              tile={tile} />
                          </td>)}
                    </tr>)
              }
            </tbody>
          </table>
        </div>
      </div>
    );
  }

}

class Tile extends React.Component {

  render() {
    let bgColor = this.props.tile.flip ? "yellow" : "grey";
    if(this.props.tile.match)
      bgColor = "green";
    return (
      <div className="tile" style={{backgroundColor: bgColor}}>
        <span>{this.props.tile.flip ? this.props.tile.letter : '#'}</span>
      </div>
    );
  }

}