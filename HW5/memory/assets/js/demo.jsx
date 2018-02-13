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
    //console.log("Got View: ", msg);
    this.setState(
      {tiles: this.ltolofl(msg.game.skel), 
        score: msg.game.points, 
        flipback: msg.game.flipback,
        matched: msg.game.matched}); 
    if(this.state.flipback != null) {
      //console.log("inside flipback")
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
    this.channel.push("guess", {row: row, col: col})
                .receive("ok", this.gotView.bind(this));     
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