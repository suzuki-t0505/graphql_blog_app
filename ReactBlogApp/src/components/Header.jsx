import { gql, useMutation } from "@apollo/client";
import { StyleSheet, View } from "react-native";
import { useNavigation } from "../context/NavigationContext";
import { useAuthTokenContext } from "../context/AuthContext";
import { HeaderItem } from "./HeaderItem";

const LOGOUT_MUTATION = gql`
  mutation{
    logOutAccount
  }
`

export const Header = () => {
  const navigation = useNavigation();
  const { authToken, deleteAuthToken } = useAuthTokenContext();
  const [logout] = useMutation(LOGOUT_MUTATION,
    {
      onCompleted: ({logOutAccount}) => {
        deleteAuthToken();
        navigation.navigate('Home')
      }
    }
  );

  return (
    <View style={style.header}>
      <HeaderItem title="Home" action={() => navigation.navigate('Home')} />
      {authToken ? (
        <>
          <HeaderItem title="NewPost" action={() => navigation.navigate("NewPost")} />
          <HeaderItem title="Logout" action={logout} />
        </>
        ) : (
        <>
          <HeaderItem title="Login" action={() => navigation.navigate("Login")} />
          <HeaderItem title="Register" action={() => navigation.navigate("Register")} />
        </>
        )} 
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