import { ApolloProvider, ApolloClient, createHttpLink, InMemoryCache, split } from "@apollo/client";
import { setContext } from '@apollo/client/link/context';
import { useCallback, useEffect } from 'react';
import { useAuthToken } from './src/hooks/useAuthToken';
import { Routers } from './src/Routers';
import * as AbsintheSocket from "@absinthe/socket";
import { createAbsintheSocketLink } from "@absinthe/socket-apollo-link";
import { hasSubscription } from "@jumpn/utils-graphql";

export default function App() {
  const { authToken, getAuthToken, saveAuthToken, deleteAuthToken } = useAuthToken();

  useEffect(() => {
    getAuthToken();
  }, [authToken]);

  const httpLink = createHttpLink({
    uri: 'http://localhost:4000/graphql'
  });

  const authLink = setContext((_, { headers }) => {
    return {headers: {...headers, authorization: authToken ? authToken : ''}}
  });

  const authedHttpLink = authLink.concat(httpLink);

  const { Socket } = require('phoenix-js');

  const phoenixSocket = new Socket('ws://localhost:4000/socket', {
    params: { authorization: authToken },
    logger: (kind, msg, data) => {
      console.log(`${kind}: ${msg}`, data)
    }
  });

  const absinthSocket = AbsintheSocket.create(phoenixSocket);

  const websocketLink =  createAbsintheSocketLink(absinthSocket);

  const link = split(
    operation => hasSubscription(operation.query),
    websocketLink,
    authedHttpLink
  );

  const client = useCallback(new ApolloClient({
    link: link,
    cache: new InMemoryCache()
  }), [authToken]);

  return (
    <ApolloProvider client={client}>
      <Routers authToken={authToken} getAuthToken={getAuthToken} saveAuthToken={saveAuthToken} deleteAuthToken={deleteAuthToken} />
    </ApolloProvider>
  );
}