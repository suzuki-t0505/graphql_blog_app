import { StatusBar } from 'expo-status-bar';
import { ApolloProvider, ApolloClient, createHttpLink, InMemoryCache } from "@apollo/client";
import { setContext } from '@apollo/client/link/context';
import { useCallback, useEffect, useState } from 'react';
import { useAuthToken } from './src/hooks/useAuthToken';
import { Routers } from './src/Routers';


export default function App() {
  const { authToken, getAuthToken, saveAuthToken, deleteAuthToken } = useAuthToken();

  const httpLink = createHttpLink({
    uri: 'http://localhost:4000/graphql'
  });

  const authLink = setContext((_, { headers }) => {
    return {headers: {...headers, authorization: authToken ? authToken : ''}}
  });

  const client = useCallback(new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache()
  }), [authToken]);

  useEffect(() => {
    getAuthToken();
  }, [authToken])
  
  return (
    <ApolloProvider client={client}>
      <Routers authToken={authToken} getAuthToken={getAuthToken} saveAuthToken={saveAuthToken} deleteAuthToken={deleteAuthToken} />
    </ApolloProvider>
  );
}