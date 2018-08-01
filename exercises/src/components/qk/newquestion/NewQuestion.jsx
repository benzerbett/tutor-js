import React from "react";
import Tags from "../elements/Tags";
import {
  Button,
  Card,
  CardBody,
  Form,
  FormGroup,
  Label,
  Input,
  FormText
} from "reactstrap";

export default class NewQuestion extends React.Component {
  render() {
    return (
      <Card className="m-5 p-5">
        <CardBody>
          <Form>
            <FormGroup>
              <Label>Question Title</Label>
              <Input placeholder="Enter the prompt of your question." />
            </FormGroup>
            <FormGroup>
              <Label>Question Body</Label>
              <Input
                type="textarea"
                rows="10"
                name="text"
                placeholder="Enter the whole content of your question."
              />
            </FormGroup>
            <FormGroup>
              <Input type="file" name="file" id="exampleFile" />
              <FormText color="muted">
                If your question has a graph of attached file, you can upload it
                here
              </FormText>
            </FormGroup>
            <FormGroup>
              <Label>Tags</Label>
              <Tags
                readOnly={false}
                placeholder="Enter the tags for your question here"
              />
            </FormGroup>
            <Button>Submit</Button>
          </Form>
        </CardBody>
      </Card>
    );
  }
}
