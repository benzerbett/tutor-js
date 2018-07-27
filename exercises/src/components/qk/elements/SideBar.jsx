import React from 'react';
import {
    Button,
    Card,
    CardBody,
    CardText,
    
} from 'reactstrap'
import Tags from './Tags'

export default class SideBar extends React.Component {
    constructor(props){
        super(props);
        this.state = {expanded: false};
        this.handleClick = this.handleClick.bind(this)
    }
    handleClick(click){
        console.log("LALALA");
        this.setState({expanded: !this.state.expanded});
        console.log(this.state)
    }
    render(){
        let content;
        content = [
            "Introduction",
            "Chemical Foundation",
            "Biological Macromolecules",
            "Cell Structure",
            "Plasma Membranes",
            "Metabolism",
            "Cellular Respiration",
            "Photosynthesis",
            "Cell Communication",
            "Cell Reproduction",
            "Genetics"
        ];
        let y = content.map((x)=><div><Button className='btn-sm btn-light' key={content.indexOf(x)}>- {x}</Button></div>);

        return (
            <div>
                <div className='text-muted mb-2'>Suggested Tags</div><Tags readOnly={false}/>
                <Button className='btn btn-light mt-3' onClick={this.handleClick}>
                    {this.state.expanded ? "> Biology" : "+ Biology"}
                </Button>
                <div className='ml-3'>
                    {this.state.expanded ? y: []}
                </div>
            </div>
    )}
}
