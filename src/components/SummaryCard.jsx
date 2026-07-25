import React from 'react';

function SummaryCard({ title, value, icon, color }) {
  return (
    <div className="card" style={{ 
      display: 'flex', 
      alignItems: 'center', 
      gap: '20px', 
      borderLeft: `4px solid ${color}`,
      padding: '24px',
      transition: 'transform 0.2s, box-shadow 0.2s'
    }}
    onMouseEnter={(e) => {
      e.currentTarget.style.transform = 'translateY(-2px)';
      e.currentTarget.style.boxShadow = 'var(--shadow-lg)';
    }}
    onMouseLeave={(e) => {
      e.currentTarget.style.transform = 'translateY(0)';
      e.currentTarget.style.boxShadow = 'var(--shadow-md)';
    }}>
      <div style={{ fontSize: '36px', filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.1))' }}>{icon}</div>
      <div>
        <div style={{ fontSize: '28px', fontWeight: '700', color: 'var(--primary-color)', letterSpacing: '-0.025em' }}>{value}</div>
        <div style={{ fontSize: '14px', color: 'var(--text-muted)', fontWeight: 500 }}>{title}</div>
      </div>
    </div>
  );
}

export default SummaryCard;