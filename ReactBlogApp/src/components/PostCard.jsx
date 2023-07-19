import { Text, View } from 'react-native';

export const PostCard = (props) => {
  return (
    <View>
      <Text>{ props.post.account.email }</Text>
      <Text>{ props.post.submitDatetime }</Text>
      <Text>{ props.post.title }</Text>
    </View>
  )
}