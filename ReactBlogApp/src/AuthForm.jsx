import { useCallback } from "react";
import { StyleSheet, Text, TextInput } from "react-native";

export const AuthForm = (props) => {
  const changeEmail = useCallback((e) => {
    props.setFormState(prevFormState => ({...prevFormState, email: e.target.value}))
  }, [props.formState]);

  const changePassword = useCallback((e) => {
    props.setFormState(prevFormState => ({...prevFormState, password: e.target.value}))
  }, [props.formState]);

  return (
    <>
      <Text style={styles.label}>Email</Text>
      <TextInput 
        style={styles.input} 
        inputMode='email' 
        value={props.formState.email}
        onChange={changeEmail}
      />
      <Text style={styles.label}>Password</Text>
      <TextInput 
        style={styles.input} 
        inputMode='text' 
        value={props.formState.password }
        onChange={changePassword}
      />
    </>
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