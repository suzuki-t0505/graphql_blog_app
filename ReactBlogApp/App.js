import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { ApolloProvider, ApolloClient, createHttpLink, InMemoryCache } from "@apollo/client";
import { setContext } from '@apollo/client/link/context';
import { PostList } from './src/PostList';
import { NewPost } from './src/NewPost';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Login } from './src/Login';
import { AUTH_TOKEN } from './src/constants';
import { useCallback, useEffect, useState } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useAuthToken } from './src/hooks/useAuthToken';


export default function App() {
  const { authToken, getAuthToken, saveAuthToken, deleteAuthToken } = useAuthToken();
  const Stack = createNativeStackNavigator();

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
    console.log(authToken)
  }, [authToken])

  return (
    <ApolloProvider client={client}>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Home">
          <Stack.Screen name="Home">
            {(props) => <PostList {...props} authToken={authToken} deleteAuthToken={deleteAuthToken} />}
          </Stack.Screen>
          {authToken ? (
            <Stack.Screen name="NewPost">
              {(props) => <NewPost {...props} authToken={authToken} deleteAuthToken={deleteAuthToken} />}
            </Stack.Screen>
            ) : null
          }

            <Stack.Screen name="Login">
              {(props) => <Login {...props} authToken={authToken} saveAuthToken={saveAuthToken} deleteAuthToken={deleteAuthToken} />}
            </Stack.Screen>

        </Stack.Navigator>
      </NavigationContainer>
    </ApolloProvider>
  );
}