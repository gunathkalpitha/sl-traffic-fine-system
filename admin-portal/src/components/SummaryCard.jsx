 import React from 'react';

function SummaryCard({ title, value, icon, color }) {
  return (
    <div style={{ ...styles.card, borderTop: `4px solid ${color}` }}>
      <div style={styles.icon}>{icon}</div>
      <div>
        <div style={styles.value}>{value}</div>
        <div style={styles.title}>{title}</div>
      </div>
    </div>
  );
}

const styles = {
  card: {
    background: '#fff',
    borderRadius: '10px',
    padding: '24px 28px',
    display: 'flex',
    alignItems: 'center',
    gap: '20px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
    flex: 1,
    minWidth: '180px',
  },
  icon: { fontSize: '36px' },
  value: { fontSize: '26px', fontWeight: '700', color: '#1a237e' },
  title: { fontSize: '13px', color: '#666', marginTop: '2px' },
};

export default SummaryCard;