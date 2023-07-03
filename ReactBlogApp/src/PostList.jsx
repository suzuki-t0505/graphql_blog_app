
import { gql, useQuery } from "@apollo/client";
import { View } from "react-native-web";
import { PostCard } from "./PostCard";

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

export const PostList = () => {
  const { data } = useQuery(POST_QUERY);

  return(
    <View>
      {data && (
        <>
          {data.posts.map(post => <PostCard key={post.id} post={post} />)}
        </>
      )}
    </View>
  )
};