import { gql, useMutation } from "@apollo/client";
import { useState } from "react"

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

export const useAuthMutation = (saveAuthToken, navigation) => {
  const [formState, setFormState] = useState(
    {
      email: '',
      password: ''
    }
  );

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

  return { formState, setFormState, register, login }
};