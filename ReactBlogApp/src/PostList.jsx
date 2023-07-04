
import { gql, useQuery } from "@apollo/client";
import { StyleSheet, View, Text } from "react-native";
import { PostCard } from "./PostCard";
import { Header } from "./Header";

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

export const PostList = (props) => {
  const { loading, data } = useQuery(POST_QUERY);

  return(
    <View>
      <Header {...props}/>
      <View style={styles.container}>
        {!loading && data ? data.posts.map(post => <PostCard key={post.id} post={post} />) : <Text>Loading...</Text>}
      </View>
    </View>
  )
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
