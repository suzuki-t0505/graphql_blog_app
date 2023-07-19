import { StyleSheet, View, Text } from "react-native";
import { PostCard } from "./components/PostCard";
import { Header } from "./components/Header";

export const PostList = (props) => {
  return(
    <View>
      <Header {...props}/>
      <View style={styles.container}>
        {!props.loading && props.data ? props.data.posts.map(post => <PostCard key={post.id} post={post} />) : <Text>Loading...</Text>}
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
