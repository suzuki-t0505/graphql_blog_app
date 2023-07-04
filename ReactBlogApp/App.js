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
import { useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const Stack = createNativeStackNavigator();

const httpLink = createHttpLink({
  uri: 'http://localhost:4000/graphql'
});

const authLink = setContext((_, { headers }) => {
  const token = AsyncStorage.getItem(AUTH_TOKEN);
  return {
    headers: {
      ...headers, authorization: token ? token : ''
    }
  }
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  // link: httpLink,
  cache: new InMemoryCache()
});

export default function App() {
  const authToken = AsyncStorage.getItem(AUTH_TOKEN)
  console.log(authToken)
  return (
    <ApolloProvider client={client}>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Home">
          <Stack.Screen name="Home">
            {(props) => <PostList {...props} authToken={authToken} />}
          </Stack.Screen>
          {authToken ? (
            <Stack.Screen name="NewPost">
              {(props) => <NewPost {...props} authToken={authToken} />}
            </Stack.Screen>
            ) : null
          }

            <Stack.Screen name="Login">
              {(props) => <Login {...props} authToken={authToken} />}
            </Stack.Screen>

        </Stack.Navigator>
      </NavigationContainer>
    </ApolloProvider>
  );
}