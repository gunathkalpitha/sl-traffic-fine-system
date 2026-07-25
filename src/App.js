<<<<<<< HEAD
import logo from './logo.svg';
=======
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import FineEntryPage from './pages/FineEntryPage';
import PaymentPage from './pages/PaymentPage';
import ConfirmationPage from './pages/ConfirmationPage';
>>>>>>> a9c6a4f42a2f550d585c0fd6d6195fa039841d31
import './App.css';

function App() {
  return (
<<<<<<< HEAD
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
=======
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
>>>>>>> a9c6a4f42a2f550d585c0fd6d6195fa039841d31
  );
}

export default App;
