import React from 'react';
import { WithContext as ReactTags } from 'react-tag-input';
import './Tags.css'

const KeyCodes = {
    comma: 188,
    enter: 13,
};

const delimiters = [KeyCodes.comma, KeyCodes.enter];

export default class Tags extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            tags: [{id: '1', text: 'Openstax'}],
            suggestions: [{ id: 'placeholder', text: 'placeholder' }]
        };
        this.handleDelete = this.handleDelete.bind(this);
        this.handleAddition = this.handleAddition.bind(this);
        this.handleDrag = this.handleDrag.bind(this);
    }

    //componentWillReceiveProps() {
    //    this.setState({ tags: this.props.tags });
    //}

    componentWillReceiveProps(){console.log(this.props)}

    handleDelete(i) {
        const { tags } = this.state;
        this.setState({
            tags: tags.filter((tag, index) => index !== i),
        });
    }

    handleAddition(tag) {
        this.setState(state => ({ tags: [...state.tags, tag] }));
    }

    handleDrag(tag, currPos, newPos) {
        const tags = [...this.state.tags];
        const newTags = tags.slice();

        newTags.splice(currPos, 1);
        newTags.splice(newPos, 0, tag);

        // re-render
        this.setState({ tags: newTags });
    }

    render() {
        const { tags, suggestions } = this.state;
        return (
            <div>
                <ReactTags
                    tags={tags}
                    suggestions={suggestions}
                    handleDelete={this.handleDelete}
                    handleAddition={this.handleAddition}
                    handleDrag={this.handleDrag}
                    delimiters={delimiters}
                    readOnly={this.props.readOnly}
                    placeholder="Search Tags"
                />
            </div>
        )
    }
}