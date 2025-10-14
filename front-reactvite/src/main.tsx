import React from 'react';
import ReactDOM from 'react-dom/client';

import { App } from '@/app';
import '@/styles/global.css';

const container = document.getElementById('root');

if (!container) {
  throw new Error('ریشهٔ برنامه پیدا نشد');
}

ReactDOM.createRoot(container).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
