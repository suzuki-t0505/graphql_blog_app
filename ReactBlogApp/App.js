import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { ApolloProvider, ApolloClient, createHttpLink, InMemoryCache } from "@apollo/client";
import { PostList } from './src/PostList';
import { NewPost } from './src/NewPost';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Login } from './src/Login';
import { AUTH_TOKEN } from './src/constants';

const Stack = createNativeStackNavigator();

const httpLink = createHttpLink({
  uri: 'http://localhost:4000/graphql'
});

const client = new ApolloClient({
  link: httpLink,
  cache: new InMemoryCache()
});

export default function App() {
  const authToken = localStorage.getItem(AUTH_TOKEN)
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
          {!authToken ? (
            <Stack.Screen name="Login">
              {(props) => <Login {...props} authToken={authToken} />}
            </Stack.Screen>
            ) : null
          }
        </Stack.Navigator>
      </NavigationContainer>
    </ApolloProvider>
  );
}