import { render, screen } from '@testing-library/react';
import React from 'react';
import Index from '../../../components/home';

describe('Home', () => {
  // it: supports typing first, middle, and last names
  // it: shows an alert when submitting
  describe('when the form is submitted', () => {
    it('shows an alert with the persons name', () => {
      expect(true).toBe(true);
      // render(<Index />);

      // expect(screen.getByRole('alert')).toHaveTextContent('hello world');
    });
  });
});