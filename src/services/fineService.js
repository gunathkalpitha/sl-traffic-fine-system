import axios from 'axios';
import { supabase } from './supabaseClient';

const BASE_URL = 'http://localhost:8080/api';

const getHeaders = () => {
  const token = localStorage.getItem('token');
  return token ? { headers: { Authorization: `Bearer ${token}` } } : {};
};

export const issueFine = async (data) => {
  // data contains: vehicleNumber, driverName, categoryId, categoryName, districtId, amount, driverEmail
  const { data: user } = await supabase.auth.getUser();
  let officerName = 'Unknown Officer';
  let officerBadge = '000';
  if (user?.user) {
    const { data: profile } = await supabase.from('profiles').select('*').eq('id', user.user.id).single();
    if (profile) {
      officerName = profile.full_name || 'Officer';
      officerBadge = profile.license_number || '000';
    }
  }

  let driverId = null;
  if (data.driverEmail) {
    try {
      const { data: profile } = await supabase
        .from('profiles')
        .select('id')
        .eq('email', data.driverEmail)
        .single();
      if (profile) {
        driverId = profile.id;
      }
    } catch (err) {
      console.warn("Could not resolve driverId from email: " + data.driverEmail, err);
    }
  }

  const dataToSubmit = {
    ...data,
    officerName,
    officerBadge,
    driverId
  };

  const response = await axios.post(`${BASE_URL}/fines/issue`, dataToSubmit, getHeaders());
  return { data: response.data };
};

export const lookupFine = async (referenceNumber) => {
  const response = await axios.get(`${BASE_URL}/fines/lookup/${referenceNumber}`, getHeaders());
  const fine = response.data;
  
  // Format to match UI expectations
  return { 
    data: {
      referenceNumber: fine.referenceNumber,
      status: fine.status,
      vehicleNumber: fine.vehicleNumber || 'N/A',
      driverName: fine.driverName || 'N/A', 
      amount: fine.amount,
      category: {
        id: fine.categoryId,
        name: fine.categoryName || 'Traffic Violation',
        description: fine.violationDescription || 'Traffic Violation'
      }
    }
  };
};

export const payFine = async (paymentData) => {
  // paymentData: { referenceNumber, paymentMethod, amount }
  const response = await axios.post(`${BASE_URL}/payments/pay`, paymentData, getHeaders());
  return { data: { success: true, payment: response.data } };
};

export const getCategories = async () => {
  const response = await axios.get(`${BASE_URL}/fines/categories`, getHeaders());
  return { data: response.data };
};

export const getDistricts = async () => {
  const response = await axios.get(`${BASE_URL}/fines/districts`, getHeaders());
  return { data: response.data };
};

export const getOfficers = async () => {
  const response = await axios.get(`${BASE_URL}/fines/officers`, getHeaders());
  // the backend returns a list of Officer objects with id, name, badgeNumber, etc.
  // map to UI expectation if needed, or pass directly
  return { data: response.data.map(o => ({ id: o.id, name: o.name, badgeNumber: o.badgeNumber })) };
};
