import fetch from 'node-fetch';

export async function handler(event) {
    const resp = await fetch('https://reqres.in/api/users?page=0', {
        method: 'GET',
        headers: {'Content-Type': 'application/json'},
    });
    const data = await resp.json();
    console.log(data);
    const response = {
        statusCode: 200,
    };
    return response;
}
