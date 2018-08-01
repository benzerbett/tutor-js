import React from 'react'
import { LinkContainer } from 'react-router-bootstrap'
import { withRouter } from 'react-router';
import { observer } from 'mobx-react';
import {
    Collapse,
    Navbar,
    NavbarToggler,
    NavbarBrand,
    Nav,
    NavItem,
    NavLink,
    Button,
    FormGroup,
} from 'reactstrap';
import { Icon } from 'react-icons-kit'
import { home } from 'react-icons-kit/icomoon/home'
import { delicious } from 'react-icons-kit/icomoon/delicious'
import { question } from 'react-icons-kit/icomoon/question'
import {fileText} from 'react-icons-kit/icomoon/fileText'
import logo from './logo.png'

@withRouter
@observer
class QKControls extends React.Component {
    constructor(props) {
        super(props);

        this.toggle = this.toggle.bind(this);
        this.state = {
            isOpen: false
        };
    }
    toggle() {
        this.setState({
            isOpen: !this.state.isOpen
        });
    }
    render() {
        return (
            <div>
                <Navbar color="light" light expand="md">
                    <NavbarBrand href="/qk/home">
                        <img className='logo ml-4' src={logo} />
                    </NavbarBrand>
        <NavbarToggler onClick={this.toggle} />
                    <Collapse isOpen={this.state.isOpen} navbar>
                        <Nav className="ml-auto" navbar>

                            <LinkContainer to="/qk/home">
                                <NavItem>
                                    <Icon className='menu-icon' icon={home} style={{color:'#737472'}}/>
                                    <NavLink href=''>Home</NavLink>
                                </NavItem>
                            </LinkContainer>
                            <LinkContainer to="/qk/subjects">
                                <NavItem>
                                    <Icon className='menu-icon' icon={delicious} style={{color:'#737472'}}/>
                                    <NavLink href=''>Menu</NavLink>
                                </NavItem>
                            </LinkContainer>
                            <LinkContainer to="/qk/help">
                                <NavItem>
                                    <Icon className='menu-icon' icon={question} style={{color:'#737472'}}/>
                                    <NavLink href=''>Help</NavLink>
                                </NavItem>
                            </LinkContainer>
                            <LinkContainer to="/qk/new-question">
                                <NavItem>
                                    <Icon className='menu-icon' icon={fileText} style={{color:'#737472'}}/>
                                    <NavLink href=''>New</NavLink>
                                </NavItem>
                            </LinkContainer>
                        </Nav>
                        <FormGroup className="form-inline my-2 ml-4">
                            <input className="form-control mr-sm-2 "
                                   type="search" placeholder="Search" />
                            <Button
                                className="btn btn-outline-mute my-2 my-sm-0 mr-4"
                                type="submit">Search</Button>
                        </FormGroup>
                    </Collapse>
                </Navbar>
            </div>
        );
    }
}


export default QKControls;
