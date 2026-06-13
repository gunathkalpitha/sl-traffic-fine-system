import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import FineEntryPage from './pages/FineEntryPage';
import PaymentPage from './pages/PaymentPage';
import ConfirmationPage from './pages/ConfirmationPage';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <div className="app-wrapper">
        <header className="app-header">
          <div className="app-header__inner">
            <span className="app-header__logo"></span>
            <span className="app-header__title">Sri Lanka Traffic Fine Payment</span>
          </div>
        </header>

        <main className="app-main">
          <Routes>
            <Route path="/" element={<Navigate to="/pay" replace />} />
            <Route path="/pay" element={<FineEntryPage />} />
            <Route path="/payment" element={<PaymentPage />} />
            <Route path="/confirmation" element={<ConfirmationPage />} />
          </Routes>
        </main>

        <footer className="app-footer">
          <p>© 2026 Sri Lanka Police Department — Traffic Fine Portal</p>
        </footer>
      </div>
    </BrowserRouter>
  );
}

export default App;
