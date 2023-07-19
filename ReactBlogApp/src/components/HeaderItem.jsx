import { View, Button } from "react-native";

export const HeaderItem = ({title, action}) => {
  return (
    <View>
      <Button title={title} onPress={action} />
    </View>
  )
}