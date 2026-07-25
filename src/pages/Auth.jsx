import React, { useState } from 'react';
import { supabase } from '../lib/supabase';
import { useNavigate } from 'react-router-dom';

function Auth() {
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [licenseNumber, setLicenseNumber] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const navigate = useNavigate();

  const handleAuth = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    setLoading(true);

    try {
      if (isRegister) {
        // Sign up with Supabase Auth
        const { data: authData, error: authError } = await supabase.auth.signUp({
          email,
          password,
        });

        if (authError) throw authError;

        if (authData.user) {
          // Insert into public.profiles
          const { error: profileError } = await supabase
            .from('profiles')
            .insert([
              {
                id: authData.user.id,
                full_name: fullName,
                license_number: licenseNumber,
                email: email,
                phone_number: phoneNumber,
                role: 'USER', // Default driver role
              },
            ]);

          if (profileError) throw profileError;

          setSuccess('Account created successfully! You can now log in.');
          setIsRegister(false);
          // Clear inputs
          setFullName('');
          setLicenseNumber('');
          setPhoneNumber('');
        }
      } else {
        // Log in with Supabase Auth
        const { error: loginError } = await supabase.auth.signInWithPassword({
          email,
          password,
        });

        if (loginError) throw loginError;
        navigate('/dashboard');
      }
    } catch (err) {
      console.error(err);
      setError(err.message || 'Authentication failed. Please check your credentials.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-card">
        <div className="auth-logo-wrapper">
          <span className="auth-logo">🚗</span>
        </div>
        <h2 className="auth-title">Sri Lanka Traffic Fines</h2>
        <p className="auth-subtitle">Driver Dashboard Access</p>

        {error && <div className="auth-error-alert">{error}</div>}
        {success && <div className="auth-success-alert">{success}</div>}

        <form onSubmit={handleAuth} className="auth-form">
          {isRegister && (
            <>
              <div className="input-group">
                <label>Full Name</label>
                <input
                  type="text"
                  placeholder="John Doe"
                  value={fullName}
                  onChange={e => setFullName(e.target.value)}
                  required
                />
              </div>

              <div className="input-group">
                <label>Driving License Number</label>
                <input
                  type="text"
                  placeholder="e.g. B1234567"
                  value={licenseNumber}
                  onChange={e => setLicenseNumber(e.target.value)}
                  required
                />
              </div>

              <div className="input-group">
                <label>Phone Number</label>
                <input
                  type="text"
                  placeholder="e.g. +94771234567"
                  value={phoneNumber}
                  onChange={e => setPhoneNumber(e.target.value)}
                  required
                />
              </div>
            </>
          )}

          <div className="input-group">
            <label>Email Address</label>
            <input
              type="email"
              placeholder="driver@example.com"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
            />
          </div>

          <button type="submit" className="btn-primary auth-submit-btn" disabled={loading}>
            {loading ? 'Processing...' : isRegister ? 'Register Account' : 'Sign In'}
          </button>
        </form>

        <div className="auth-toggle">
          {isRegister ? (
            <p>
              Already have an account?{' '}
              <button onClick={() => setIsRegister(false)} className="btn-link">
                Sign In
              </button>
            </p>
          ) : (
            <p>
              Don't have an account?{' '}
              <button onClick={() => setIsRegister(true)} className="btn-link">
                Create Account
              </button>
            </p>
          )}
        </div>
      </div>
    </div>
  );
}

export default Auth;
