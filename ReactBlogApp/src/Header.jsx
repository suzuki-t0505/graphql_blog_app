import { gql, useMutation } from "@apollo/client";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { Button, StyleSheet, Text, TouchableOpacity, View } from "react-native";

const LOGOUT_MUTATION = gql`
  mutation{
    logOutAccount
  }
`

export const Header = (props) => {
  const [logout] = useMutation(LOGOUT_MUTATION,
    {
      onCompleted: ({logOutAccount}) => {
        props.deleteAuthToken();
        props.navigation.navigate('Home')
      }
    }
  );

  return (
    <View style={style.header}>
      <View>
        <Button
          title="Home"
          onPress={() => props.navigation.navigate('Home')}
        />
      </View>
      {props.authToken ? (
        <>
          <View>
            <Button
              title="NewPost"
              onPress={() => props.navigation.navigate("NewPost")}
              />
          </View>

          <View>
            <Button
              title="Logout"
              onPress={logout}
            />
            </View>
          </>
        ) : null
      }
      
      {!props.authToken ? (
        <View>
          <Button
            title="Login"
            onPress={() => props.navigation.navigate("Login")}
          />
        </View>
        ) : null
      } 
    </View>
  )
}

const style = StyleSheet.create({
  header: {
    marginLeft: 4,
    flexDirection: 'row',
    alignContent: 'space-around',
    backgroundColor: '#fff'
  },
  button: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 4,
    backgroundColor: 'Blue',

  }
})