import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Login } from './Login';
import { NewPost } from './NewPost';
import { PostList } from './PostList';
import { gql, useQuery } from '@apollo/client';
import { Register } from './Register';
import { Navigation } from './context/NavigationContext';
import { useAuthTokenContext } from './context/AuthContext';

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

const POST_ADDED_SUBSCRIPTION = gql`
  subscription{
    postAdded(topic: "all"){
      id
      title
      body
      submitDatetime
      account{
        email
      }
    }
  }
`

export const Routers = (props) => {
  const Stack = createNativeStackNavigator();
  const { authToken } = useAuthTokenContext();
  const { loading, data, refetch, subscribeToMore } = useQuery(POST_QUERY);

  subscribeToMore({
    document: POST_ADDED_SUBSCRIPTION,
    updateQuery: (prev, { subscriptionData }) => {
      if (!subscriptionData.data) return prev;
      const newPost = subscriptionData.data.postAdded;
      const exists = prev.posts.find(({ id }) => id === newPost.id);
      if (exists) return prev;
      return Object.assign({}, prev, {
        posts: [newPost, ...prev.posts]
      });
    }
  });
  

  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName='Home'>
        <Stack.Screen name="Home">
          { ({navigation}) => <Navigation navigation={navigation}><PostList data={data} loading={loading} /></Navigation> }
        </Stack.Screen>
        {authToken ? (
          <Stack.Screen name="NewPost">
            { ({navigation}) => <Navigation navigation={navigation}><NewPost refetch={refetch} /></Navigation> }
          </Stack.Screen>
          ) : null
        }
        {!authToken ? (
          <>
            <Stack.Screen name="Login">
              { ({navigation}) => <Navigation navigation={navigation}><Login /></Navigation> }
            </Stack.Screen>
            <Stack.Screen name="Register">
              { ({navigation}) => <Navigation navigation={navigation}><Register /></Navigation> }
            </Stack.Screen>
          </>
          ) : null
        }        
      </Stack.Navigator>
    </NavigationContainer>
  )
}
