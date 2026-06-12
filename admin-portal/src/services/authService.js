 import axios from 'axios';

const BASE_URL = 'http://localhost:8080/api';

export const loginUser = async (username, password) => {
  const response = await axios.post(`${BASE_URL}/auth/login`, { username, password });
  return response.data;
};