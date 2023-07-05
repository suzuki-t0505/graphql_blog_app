import { useCallback, useEffect, useState } from 'react'
import { View, TextInput, StyleSheet, SafeAreaView, Button, Text } from 'react-native'
import { Header } from './Header'
import { gql, useMutation } from "@apollo/client";
import { AUTH_TOKEN } from './constants';
import AsyncStorage from '@react-native-async-storage/async-storage';

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
`

export const Login = (props) => {
  const [formState, setFormState] = useState(
    {
      email: '',
      password: ''
    }
  );

  const changeEmail = useCallback((e) => {
    setFormState(prevFormState => ({...prevFormState, email: e.target.value}))
  }, [formState]);

  const changePassword = useCallback((e) => {
    setFormState(prevFormState => ({...prevFormState, password: e.target.value}))
  }, [formState]);

  const [login] = useMutation(LOGIN_MUTATION, {
    variables: {
      email: formState.email,
      password: formState.password
    },
    onCompleted: ({logInAccount}) => {
      props.saveAuthToken(logInAccount.token);
      props.navigation.navigate('Home');
    }
  })

  // useEffect(() => {
  //   console.log(formState)
  // }, [formState])
  
  return (
    <View>
      <Header {...props} />
      <SafeAreaView>
        <Text style={styles.label}>Email</Text>
        <TextInput 
          style={styles.input} 
          inputMode='email' 
          value={formState.email}
          onChange={changeEmail}
        />
        <Text style={styles.label}>Password</Text>
        <TextInput 
          style={styles.input} 
          inputMode='text' 
          value={formState.password }
          onChange={changePassword}
        />
        <Button
          title='Login'
          onPress={login}
        />
      </SafeAreaView>
    </View>
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