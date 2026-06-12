 import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { loginUser } from '../services/authService';

function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleLogin = async () => {
    setError('');
    setLoading(true);
    try {
      const data = await loginUser(username, password);
      if (data.role !== 'ADMIN') {
        setError('Access denied. Admins only.');
        setLoading(false);
        return;
      }
      login(data.token, data.role);
      navigate('/');
    } catch (err) {
      setError('Invalid username or password.');
    }
    setLoading(false);
  };

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <div style={styles.logo}>🚔</div>
        <h2 style={styles.title}>Sri Lanka Police</h2>
        <p style={styles.subtitle}>Traffic Fine Admin Portal</p>

        {error && <div style={styles.error}>{error}</div>}

        <input
          style={styles.input}
          type="text"
          placeholder="Username"
          value={username}
          onChange={e => setUsername(e.target.value)}
        />
        <input
          style={styles.input}
          type="password"
          placeholder="Password"
          value={password}
          onChange={e => setPassword(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && handleLogin()}
        />

        <button
          style={{ ...styles.button, opacity: loading ? 0.7 : 1 }}
          onClick={handleLogin}
          disabled={loading}
        >
          {loading ? 'Signing in...' : 'Sign In'}
        </button>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    background: 'linear-gradient(135deg, #1a237e 0%, #0d47a1 100%)',
  },
  card: {
    background: '#fff',
    borderRadius: '12px',
    padding: '48px 40px',
    width: '100%',
    maxWidth: '380px',
    boxShadow: '0 8px 32px rgba(0,0,0,0.18)',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  logo: { fontSize: '48px', marginBottom: '8px' },
  title: { margin: '0 0 4px', fontSize: '22px', fontWeight: '700', color: '#1a237e' },
  subtitle: { margin: '0 0 28px', fontSize: '13px', color: '#666' },
  error: {
    background: '#ffebee',
    color: '#c62828',
    padding: '10px 16px',
    borderRadius: '6px',
    marginBottom: '16px',
    width: '100%',
    fontSize: '13px',
    textAlign: 'center',
  },
  input: {
    width: '100%',
    padding: '12px 14px',
    marginBottom: '14px',
    borderRadius: '6px',
    border: '1px solid #ddd',
    fontSize: '14px',
    outline: 'none',
    boxSizing: 'border-box',
  },
  button: {
    width: '100%',
    padding: '13px',
    background: '#1a237e',
    color: '#fff',
    border: 'none',
    borderRadius: '6px',
    fontSize: '15px',
    fontWeight: '600',
    cursor: 'pointer',
    marginTop: '4px',
  },
};

export default LoginPage;