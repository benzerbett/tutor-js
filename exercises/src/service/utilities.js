import React from 'react'

export function addBreak(text) {
    return text.toString().split('\n')
        .map((item, key) => {
            return <span key={key}>{item}<br/></span>
        })
}
