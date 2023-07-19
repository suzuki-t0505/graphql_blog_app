import { createContext, useContext } from 'react';

const AuthTokenContext = createContext();

export const AuthToken = ({ authToken, getAuthToken, saveAuthToken, deleteAuthToken, children }) => {
  return (
    <AuthTokenContext.Provider value={{authToken, getAuthToken, saveAuthToken, deleteAuthToken}}>
      { children }
    </AuthTokenContext.Provider>
  )
}

export const useAuthTokenContext = () => useContext(AuthTokenContext);