import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) {
  ReactDOM.render(<Game channel={channel} />, root);
}

class Game extends React.Component {

  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp); });
 
    this.ltolofl = this.ltolofl.bind(this);
    this.reset = this.reset.bind(this);  
    this.checkHit = this.checkHit.bind(this);
    this.createArray = this.createArray.bind(this);
        
    this.state = {
      tiles: [],
      activeTile: null,
      score: 0,
      flipback: null,
      matched: ""
    };  
  }

  gotView(msg) {
    console.log("Got View: ", msg);
    this.setState(
      {tiles: this.ltolofl(msg.game.skel), 
        score: msg.game.points, 
        flipback: msg.game.flipback,
        matched: msg.game.matched}); 
    if(this.state.flipback != null) {
      console.log("inside flipback")
      this.channel.push("nomatch", {})
                .receive("ok", this.gotView.bind(this));
    }
    if(this.state.matched.length === 8) {
      alert("You win! Score: " + (this.state.score));
    }
  }

  ltolofl(inittiles) {
    var iniTiles = this.createArray(4,4);
    var k = 0;
    for(var i=0; i<4; i++){
      for(var j=0; j<4; j++){
        iniTiles[i][j] = inittiles[k];
        k++;
      }
    }
    return iniTiles;
  }

  createArray(x, y){
    var myarray=new Array(x)
    for (var i=0; i < x; i++)
      myarray[i]=new Array(y)
    return myarray;
  }

  tileClick(row, col) {
    /*if(this.state.activeTile != null) {
      this.channel.push("matched", {row: row, col: col})
                .receive("ok", this.gotView.bind(this));
    } else {
      this.channel.push("guess", {row: row, col: col})
                .receive("ok", this.gotView.bind(this));
    }*/
    
    this.channel.push("guess", {row: row, col: col})
                .receive("ok", this.gotView.bind(this));
    
    //if (!this.state.tiles[row][col].flip) {
      //this.checkHit(this.state.tiles[row][col].letter, row, col);      
    //}        
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
          this.setState({tiles, activeTile: null, score: this.state.score, inactive: false});
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
    this.state = {
      tiles: [],
      activeTile: null,
      score: 0,
      flipback: null,
      matched: ""
    };
    this.channel.push("reset", {})
                .receive("ok", this.gotView.bind(this));
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