import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

function Navbar() {
  const { logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { label: '📊 Dashboard', path: '/' },
    { label: '🗺️ Districts', path: '/districts' },
    { label: '📋 Categories', path: '/categories' },
  ];

  return (
    <div style={styles.navbar}>
      <div style={styles.brand}>🚔 Traffic Fine Admin</div>
      <div style={styles.navLinks}>
        {navItems.map(item => (
          <button
            key={item.path}
            style={{
              ...styles.navBtn,
              ...(location.pathname === item.path ? styles.navBtnActive : {}),
            }}
            onClick={() => navigate(item.path)}
          >
            {item.label}
          </button>
        ))}
      </div>
      <button style={styles.logoutBtn} onClick={() => { logout(); navigate('/login'); }}>
        Sign Out
      </button>
    </div>
  );
}

const styles = {
  navbar: {
    display: 'flex',
    alignItems: 'center',
    background: '#1a237e',
    padding: '0 32px',
    height: '60px',
    gap: '8px',
  },
  brand: {
    color: '#fff',
    fontWeight: '700',
    fontSize: '16px',
    marginRight: '24px',
    whiteSpace: 'nowrap',
  },
  navLinks: { display: 'flex', gap: '4px', flex: 1 },
  navBtn: {
    background: 'transparent',
    color: '#90caf9',
    border: 'none',
    padding: '8px 16px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '13px',
    fontWeight: '500',
  },
  navBtnActive: {
    background: 'rgba(255,255,255,0.15)',
    color: '#fff',
  },
  logoutBtn: {
    background: 'rgba(255,255,255,0.1)',
    color: '#fff',
    border: '1px solid rgba(255,255,255,0.3)',
    padding: '7px 16px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '13px',
  },
};

export default Navbar;