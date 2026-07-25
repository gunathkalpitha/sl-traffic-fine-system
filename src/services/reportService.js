 import axios from 'axios';

const BASE_URL = 'http://localhost:8080/api';

const getHeaders = () => ({
  headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
});

export const getSummary = () =>
  axios.get(`${BASE_URL}/admin/reports/summary`, getHeaders());

export const getDistrictReport = () =>
  axios.get(`${BASE_URL}/admin/reports/districts`, getHeaders());

export const getCategoryReport = () =>
  axios.get(`${BASE_URL}/admin/reports/categories`, getHeaders());