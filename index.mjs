import fetch from 'node-fetch';

export async function handler(event) {
    const resp = await fetch('https://reqres.in/api/users?page=0', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: '{}'
    });
    const data = await resp.json();
    console.log(data);
    const response = {
        statusCode: 200,
    };
    return response;
}
