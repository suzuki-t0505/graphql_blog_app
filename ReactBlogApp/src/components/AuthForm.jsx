import { useCallback, useState } from "react";
import { gql, useMutation } from "@apollo/client";
import { SafeAreaView, StyleSheet, Text, TextInput, Button } from "react-native";
import { useNavigation } from '../context/NavigationContext';
import { useAuthTokenContext } from '../context/AuthContext';

const LOGIN_MUTATION = gql`
  mutation($email: String! $password: String!){
    logInAccount(email: $email password: $password){
      token
      account{
        id
        email
      }
    }
  }
`;

const REGISTER_MUTATION = gql`
  mutation($email: String! $password: String!){
    registerAccount(email: $email password: $password) {
      email
    }
  }
`;


export const AuthForm = (props) => {
  const [formState, setFormState] = useState({email: '', password: ''});
  const navigation = useNavigation();
  const { saveAuthToken } = useAuthTokenContext();

  const [register] = useMutation(REGISTER_MUTATION, {
    variables: {
      email: formState.email,
      password: formState.password
    },
    onCompleted: ({registerAccount}) => {
      login();
    }
  });

  const [login] = useMutation(LOGIN_MUTATION, {
    variables: {
      email: formState.email,
      password: formState.password
    },
    onCompleted: ({logInAccount}) => {
      saveAuthToken(logInAccount.token);
      navigation.navigate('Home');
    }
  });

  const changeEmail = useCallback((e) => {
    setFormState(prevFormState => ({...prevFormState, email: e.target.value}))
  }, [formState]);

  const changePassword = useCallback((e) => {
    setFormState(prevFormState => ({...prevFormState, password: e.target.value}))
  }, [formState]);

  const SubmitButton = ({type}) => {
    if (type === 'login')
      return (<Button title="Login" onPress={login} />)
    else
      return (<Button title="Register" onPress={register} />)
  }

  return (
    <SafeAreaView>
      <Text style={styles.label}>Email</Text>
      <TextInput style={styles.input} inputMode='email' value={formState.email} onChange={changeEmail} />
      <Text style={styles.label}>Password</Text>
      <TextInput style={styles.input} inputMode='text' value={formState.password} onChange={changePassword} />
      <SubmitButton type={props.type} />
    </SafeAreaView>
  )
};

const styles = StyleSheet.create({
  input: {
    height: 40,
    marginHorizontal: 12,
    marginVertical: 6,
    borderWidth: 1,
    padding: 10
  },
  label: {
    fontWeight: 'bold',
    marginLeft: 12,
    marginTop: 10
  }
});