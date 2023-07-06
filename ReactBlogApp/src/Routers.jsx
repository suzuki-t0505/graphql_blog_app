import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Login } from './Login';
import { NewPost } from './NewPost';
import { PostList } from './PostList';
import { gql, useQuery } from '@apollo/client';
import { Register } from './Register';

const POST_QUERY = gql`
  {
    posts{
      id
      title
      submitDatetime
      account{
        email
      }
    }
  }
`;

export const Routers = (props) => {
  const Stack = createNativeStackNavigator();
  const {authToken, saveAuthToken, deleteAuthToken} = props;
  const { loading, data, refetch } = useQuery(POST_QUERY)

  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName='Home'>
        <Stack.Screen name="Home">
          {(props) => <PostList {...props} authToken={authToken} deleteAuthToken={deleteAuthToken} data={data} loading={loading} />}
        </Stack.Screen>
        {authToken ? (
          <Stack.Screen name="NewPost">
            {(props) => <NewPost {...props} authToken={authToken} deleteAuthToken={deleteAuthToken} refetch={refetch} />}
          </Stack.Screen>
          ) : null
        }
        {!authToken ? (
          <>
            <Stack.Screen name="Login">
              {(props) => <Login {...props} authToken={authToken} saveAuthToken={saveAuthToken} deleteAuthToken={deleteAuthToken} />}
            </Stack.Screen>
            <Stack.Screen name="Register">
              {(props) => <Register {...props} authToken={authToken} saveAuthToken={saveAuthToken} deleteAuthToken={deleteAuthToken} />}
            </Stack.Screen>
          </>
          ) : null
        }        
      </Stack.Navigator>
    </NavigationContainer>
  )
}