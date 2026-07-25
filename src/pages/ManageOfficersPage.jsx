import React, { useEffect, useState } from 'react';
import Navbar from '../components/Navbar';
import { supabase } from '../services/supabaseClient';

function ManageOfficersPage() {
  const [officers, setOfficers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Form State
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    licenseNumber: '',
    phoneNumber: '',
    password: ''
  });
  const [formLoading, setFormLoading] = useState(false);
  const [formMessage, setFormMessage] = useState({ type: '', text: '' });

  const fetchOfficers = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('role', 'OFFICER');

    if (error) {
      setError('Failed to fetch officers: ' + error.message);
    } else {
      setOfficers(data || []);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchOfficers();
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormMessage({ type: '', text: '' });

    try {
      // Create an isolated client so we don't log the admin out!
      const { createClient } = await import('@supabase/supabase-js');
      const { supabaseUrl, supabaseKey } = await import('../services/supabaseClient');
      const tempClient = createClient(supabaseUrl, supabaseKey, {
        auth: { persistSession: false, autoRefreshToken: false }
      });

      // 0. Check if license number exists to prevent dangling auth records
      const { data: existingOfficers, error: checkError } = await supabase
        .from('profiles')
        .select('id')
        .eq('license_number', formData.licenseNumber);
      
      if (checkError) throw checkError;
      if (existingOfficers && existingOfficers.length > 0) {
        throw new Error('An officer with this Badge / License Number already exists.');
      }

      // 1. Sign up the user
      const { data: authData, error: authError } = await tempClient.auth.signUp({
        email: formData.email,
        password: formData.password
      });

      if (authError) throw authError;

      // 2. Upsert into profiles using the tempClient (which is now authenticated as the new user, so it passes RLS `auth.uid() = id`)
      const newUserId = authData.user.id;
      
      const { error: profileError } = await tempClient.from('profiles').upsert([{
        id: newUserId,
        full_name: formData.fullName,
        email: formData.email,
        license_number: formData.licenseNumber,
        phone_number: formData.phoneNumber,
        role: 'OFFICER'
      }]);

      if (profileError) throw profileError;

      setFormMessage({ type: 'success', text: `Officer registered successfully!` });
      setFormData({ fullName: '', email: '', licenseNumber: '', phoneNumber: '', password: '' });
      
      // Refresh the table
      fetchOfficers();
    } catch (err) {
      setFormMessage({ type: 'error', text: err.message || 'Failed to register officer.' });
    }
    setFormLoading(false);
  };

  return (
    <>
      <Navbar />
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">Manage Officers</h1>
            <p className="page-subtitle">View and register traffic officers.</p>
          </div>
        </div>

        {error && <div className="login-error">{error}</div>}

        <div style={{ display: 'flex', gap: '24px', flexWrap: 'wrap', alignItems: 'flex-start' }}>
          
          <div className="card" style={{ flex: '1 1 300px', minWidth: '300px' }}>
            <h2 className="card-title">Register Officer</h2>
            
            {formMessage.text && (
              <div className="login-error" style={{
                background: formMessage.type === 'success' ? '#ecfdf5' : '#fef2f2',
                color: formMessage.type === 'success' ? '#047857' : '#b91c1c',
                borderColor: formMessage.type === 'success' ? '#6ee7b7' : '#fca5a5',
                marginBottom: '16px'
              }}>
                {formMessage.text}
              </div>
            )}

            <form onSubmit={handleSubmit}>
              <div className="input-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value={formData.fullName} onChange={handleChange} required />
              </div>
              <div className="input-group">
                <label>Email Address</label>
                <input type="email" name="email" value={formData.email} onChange={handleChange} required />
              </div>
              <div className="input-group">
                <label>Badge / License Number</label>
                <input type="text" name="licenseNumber" value={formData.licenseNumber} onChange={handleChange} required />
              </div>
              <div className="input-group">
                <label>Phone Number</label>
                <input type="text" name="phoneNumber" value={formData.phoneNumber} onChange={handleChange} placeholder="e.g. 0771234567" />
              </div>
              <div className="input-group">
                <label>Initial Password</label>
                <input type="password" name="password" value={formData.password} onChange={handleChange} required minLength={6} placeholder="Enter initial password" />
              </div>
              <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
                <button type="submit" className="btn-primary" disabled={formLoading} style={{ flex: 1 }}>
                  {formLoading ? 'Registering...' : 'Register Officer'}
                </button>
                <button type="button" className="btn-secondary" onClick={() => alert('Sending SMS is Coming Soon!')} style={{ flex: 1, background: '#f1f5f9', color: '#475569', border: '1px solid #cbd5e1' }}>
                  📱 Send SMS
                </button>
              </div>
            </form>
          </div>

          <div className="table-container" style={{ flex: '2 1 400px', minWidth: '350px' }}>
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Badge No</th>
                  <th>Email</th>
                  <th>Joined</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr><td colSpan="4">Loading officers...</td></tr>
                ) : officers.length === 0 ? (
                  <tr><td colSpan="4">No officers found.</td></tr>
                ) : (
                  officers.map(officer => (
                    <tr key={officer.id}>
                      <td style={{ fontWeight: 500 }}>{officer.full_name}</td>
                      <td>{officer.license_number}</td>
                      <td>{officer.email}</td>
                      <td>{officer.updated_at ? new Date(officer.updated_at).toLocaleDateString() : 'N/A'}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

        </div>
      </div>
    </>
  );
}

export default ManageOfficersPage;
