import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

function Navbar() {
  const { logout, role } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const allNavItems = [
    { label: 'Dashboard', path: '/', roles: ['ADMIN'] },
    { label: 'Manage Officers', path: '/manage-officers', roles: ['ADMIN'] },
    { label: 'Issue Fine', path: '/issue-fine', roles: ['OFFICER'] },
    { label: 'Lookup & Pay', path: '/lookup', roles: ['ADMIN', 'OFFICER'] },
    { label: 'Districts', path: '/districts', roles: ['ADMIN'] },
    { label: 'Categories', path: '/categories', roles: ['ADMIN'] },
    { label: 'Settings', path: '/settings', roles: ['ADMIN', 'OFFICER'] },
  ];

  const navItems = allNavItems.filter(item => item.roles.includes(role));

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <div className="navbar-brand">
          <span className="navbar-logo">🚔</span>
          <span className="navbar-title">Traffic Fine System</span>
        </div>
        <div className="navbar-links">
          {navItems.map(item => (
            <button
              key={item.path}
              className={`nav-btn ${location.pathname === item.path ? 'active' : ''}`}
              onClick={() => navigate(item.path)}
            >
              {item.label}
            </button>
          ))}
        </div>
        <div className="navbar-actions">
          <button className="nav-logout-btn" onClick={() => { logout(); navigate('/login'); }}>
            Sign Out
          </button>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;