import request from './request'

function get(id) {
    return request({
        url:    `/questions/${id}`,
        method: 'GET'
    });
}

function getAll() {
    return request({
        url: '/questions',
        method: 'GET'
    })
}

function create({data}) {
    return request({
        url:    '/questions/create',
        method: 'POST',
        data: data
    });
}

const QuestionService = {
    get, getAll, create //update, delete, etc. ...
};

export default QuestionService;