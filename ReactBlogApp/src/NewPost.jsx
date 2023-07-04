import { Text, View } from "react-native";
import { Header } from './Header'

export const NewPost = (props) => {
  return (
    <View>
      <Header {...props} />
      <Text>New Post</Text>
    </View>
  )
}